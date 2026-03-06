import os

if __name__ == "__main__":
    # this file is meant to be used in dev

    if os.environ.get("APPLICATION_ENVIRONMENT_FILE"):
        import dotenv

        dotenv.load_dotenv(os.environ["APPLICATION_ENVIRONMENT_FILE"])

    import app

    app.run()

