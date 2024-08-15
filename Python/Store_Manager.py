import firebase_admin
from firebase_admin import credentials, storage, firestore
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)

class Database:
    def __init__(self):
        # Replace the projectID eg.
        self.bucket_name = 'owen-basketball-analyzer.appspot.com'
        logging.info(f"Initializing Firebase with bucket: {self.bucket_name}")

        # You need to download the serviceaccount.json
        self.fb_cred = 'C:\\Users\\wuutt\\OneDrive\\Desktop\\Project\\Basketball-python\\owen-basketball-analyzer-firebase-adminsdk-y3la8-bb5d47692b.json'

        # Initialize Firebase app if not already initialized
        if not firebase_admin._apps:
            try:
                cred = credentials.Certificate(self.fb_cred)
                firebase_admin.initialize_app(cred, {'storageBucket': self.bucket_name})
                logging.info("Firebase app initialized successfully.")
            except Exception as e:
                logging.error(f"Failed to initialize Firebase app: {e}")
                raise

        # Connect to Firestore
        try:
            self.db = firestore.client()
            logging.info("Connected to Firestore successfully.")
        except Exception as e:
            logging.error(f"Failed to connect to Firestore: {e}")
            raise

    def update_firestore(self, collection: str, userid: str, data: dict):
        try:
            collection_ref = self.db.collection(collection)  # Reference to collection
            doc_ref = collection_ref.document(userid)  # Reference to document
            doc_ref.set(data, merge=True)  # Merge data into the document
            logging.info(f"Firestore updated successfully for user {userid} in collection {collection}.")
        except Exception as e:
            logging.error(f"Failed to update Firestore: {e}")
            raise

    def exists_on_cloud(self, filename):
        try:
            bucket = storage.bucket()  # Get the storage bucket
            blob = bucket.blob(filename)  # Create a blob (object) for the file
            if blob.exists():  # Check if the file exists on the cloud
                logging.info(f"File {filename} exists on the cloud.")
                return blob.public_url  # Return the public URL if it exists
            else:
                logging.info(f"File {filename} does not exist on the cloud.")
                return False
        except Exception as e:
            logging.error(f"Error checking if file exists on cloud: {e}")
            raise

    def upload_file(self, firebase_path, local_path):
        try:
            url = self.exists_on_cloud(firebase_path)
            if not url:
                bucket = storage.bucket()  # Get the storage bucket
                blob = bucket.blob(firebase_path)  # Create a blob (object) for the file
                blob.upload_from_filename(local_path)  # Upload the file to Firebase Storage
                logging.info(f"File {local_path} uploaded to cloud at {firebase_path}.")
                blob.make_public()  # Make the file publicly accessible
                url = blob.public_url  # Get the public URL of the file
            return url  # Return the URL of the uploaded file
        except Exception as e:
            logging.error(f"Failed to upload file to Firebase: {e}")
            raise
