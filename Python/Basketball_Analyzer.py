import os
from pathlib import Path

import cv2
from ultralytics import YOLO  # Importing YOLO for object detection
from ultralytics.utils.plotting import Annotator  # Utility for drawing boxes and labels on images

path = 'runs\\detect\\train20\\weights\\best.pt'  # Path to the pre-trained model weights
basketball_model = YOLO(path)  # Loading the YOLO model

# Define color mapping for each class recognized in the basketball analysis
class_colors = {
    "ball": (255, 0, 0),  # Red for basketball
    "made": (0, 255, 0),  # Green for successful shots
    "person": (0, 0, 255),  # Blue for players
    "rim": (255, 255, 0),  # Yellow for the rim
    "shoot": (255, 0, 255)  # Magenta for shooting actions
}


def detect_object(frame):
    """
    Detects objects in a frame using the loaded YOLO model.

    Parameters:
    - frame: The current video frame to process.

    Returns:
    - The frame with annotated detections.
    - A boolean indicating whether a shot was made.
    - A list of x-axis center positions of detected persons or shoots.
    """
    results = basketball_model(frame)
    annotator = Annotator(frame)
    person_centers = []
    is_made = False
    for r in results:
        boxes = r.boxes
        for box in boxes:
            b = box.xyxy[0]  # Bounding box coordinates
            conf = r.boxes.conf.tolist()  # Confidence score
            c = box.cls  # Class ID
            class_name = basketball_model.names[int(c)]  # Class name
            color = class_colors.get(class_name, (255, 128, 128))  # Default color for unidentified classes

            if class_name == "made":
                is_made = True
            if class_name == "person" or class_name == "shoot":
                center_x = int((b[0] + b[2]) / 2)
                person_centers.append(center_x)

            annotator.box_label(b, class_name, color=color)
    frame = annotator.result()
    return frame, is_made, person_centers


def resize_image(image):
    # Get the height and width of the image
    h, w, _ = image.shape
    # Reduce the height and width by half
    h, w = h // 2, w // 2
    # Resize the image to the new dimensions
    image = cv2.resize(image, (w, h))
    return image, h, w


def resize_original(image, h, w):
    # Resize the image back to its original dimensions
    image = cv2.resize(image, (w, h))
    return image


def make_directory(name: str):
    # Check if the directory exists; if not, create it
    if not os.path.isdir(name):
        os.mkdir(name)


def put_text(frame, text, org):
    # Define the font type for the text
    font = cv2.FONT_HERSHEY_SIMPLEX
    # Define the scale of the font
    fontScale = 1
    # Define the color of the text (BGR format)
    color = (255, 0, 0)
    # Define the thickness of the text
    thickness = 2
    # Add the text to the frame
    frame = cv2.putText(frame, text, org, font, fontScale, color, thickness, cv2.LINE_AA)
    return frame


def setup_video_tool(cap, video_path):
    # Create the output directory for processed videos
    make_directory('basketball_output')
    # Get the video frame dimensions
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    # Set a fixed frames per second (fps) to slow down the output video
    fps = 20
    # Define the path for the output video
    output_path = f'basketball_output/{Path(video_path).stem}_output.mp4'
    # Create a VideoWriter object to write the processed video
    out = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc('m', 'p', '4', 'v'), int(fps), (int(width), int(height)))
    return height, width, out, output_path


def write_scores(frame, left, right, score):
    # Display the total, left, and right scores on the frame
    frame = put_text(frame, f'Total Score: {score}', (50, 50))
    frame = put_text(frame, f'Left Score: {left}', (50, 100))
    frame = put_text(frame, f'Right Score: {right}', (50, 150))
    return frame


def update_score(current_time, frame, left, person_pos, right, score, scores, w):
    # Save the current frame with the updated score
    cv2.imwrite(f'images/img_{score}.png', frame)
    # Increment the score
    score += 1
    # Update the score based on the person's position (left or right)
    if person_pos[0] <= w // 2:
        left += 1
    else:
        right += 1
    # Record the score details
    scores.append({'person_pos': person_pos[0] / w, 'time': current_time, 'score': score, 'right': right, 'left': left})
    return left, current_time, right, score

def process_video(video_path, sm, is_show=False):
    print('=====Processing ======')
    previous_detection_time = 0
    min_time_between_detections = 1000
    cap = cv2.VideoCapture(video_path)
    score, left, right = 0, 0, 0
    scores = []
    current_frame = 0
    org_h, org_w, out, output_path = setup_video_tool(cap, video_path)
    make_directory('images')

    if not cap.isOpened():
        print("Error opening video stream or file")

    while True:
        ret, frame = cap.read()

        if ret:
            frame, h, w = resize_image(frame)
            frame, is_made, person_pos = detect_object(frame)
            current_time = cap.get(cv2.CAP_PROP_POS_MSEC)

            if is_made and current_time - previous_detection_time >= min_time_between_detections:
                left, previous_detection_time, right, score = update_score(current_time, frame, left, person_pos, right, score, scores, w)

            frame = write_scores(frame, left, right, score)

            # Only show the frame if `is_show` is True and a display is available
            if is_show and (os.getenv('DISPLAY') or os.name == 'nt'):
                cv2.imshow('Pose Detection', frame)
                if cv2.waitKey(25) & 0xFF == ord('q'):
                    break

            frame = resize_original(frame, org_h, org_w)
            out.write(frame)
            current_frame += 1
        else:
            break

    print('===== Finish Processing ======')

    cap.release()
    out.release()

    if is_show and (os.getenv('DISPLAY') or os.name == 'nt'):
        cv2.destroyAllWindows()

    print('====save video========')
    url = sm.upload_file(output_path, output_path)
    if os.path.isfile(output_path):
        os.remove(output_path)
    result = {'scores': scores, 'url': url}
    return result

if __name__ == '__main__':
    from store_manager import Database

    sm = Database()
    result = process_video(video_path='sample_video/basketball.mp4', sm=sm, is_show=True)
    print(result)