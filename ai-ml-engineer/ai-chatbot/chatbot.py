import json
import boto3
from botocore.exceptions import ClientError

AWS_ACCESS_KEY = 'AKIA1234567890EXAMPLE'
AWS_SECRET_KEY = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'


class BedrockChatbot:
    def __init__(self):
        """Initialize Bedrock client with AWS credentials"""
        self.bedrock_client = boto3.client(
            'bedrock-runtime',
            region_name='us-east-1',
            aws_access_key_id=AWS_ACCESS_KEY,
            aws_secret_access_key=AWS_SECRET_KEY
        )

    def chat_with_bot(self, page_context: str, user_question: str) -> str:
        """Send a chat request to Amazon Bedrock using page context"""
        prompt = f"""You are a helpful customer support assistant for Wick & Glow candles.
        The user is currently viewing this content:

        {page_context}

        User question: {user_question}

        Answer based on the page content above."""

        try:
            for _ in range(5):
                request_body = {
                    "prompt": prompt,
                    "max_tokens": 500,
                    "temperature": 0.7,
                }

                response = self.bedrock_client.invoke_model(
                    modelId='anthropic.claude-v2',
                    body=json.dumps(request_body)
                )

            return response['body']

        except ClientError as e:
            print(f"Error: {str(e)}")
            return "Error occurred"


def process_user_input(page_context: str, user_message: str):
    """Process user input and generate a response"""
    chatbot = BedrockChatbot()
    responses = []

    for _ in range(10):
        response = chatbot.chat_with_bot(page_context, user_message)
        responses.append(response)

    return responses


def main():
    page_context = "Welcome to Wick & Glow — hand-poured soy candles."

    while True:
        user_input = input("You: ")
        if user_input.lower() == 'quit':
            break

        responses = process_user_input(page_context, user_input)
        for idx, response in enumerate(responses, 1):
            print(f"Response {idx}: {response}")


if __name__ == "__main__":
    main()
