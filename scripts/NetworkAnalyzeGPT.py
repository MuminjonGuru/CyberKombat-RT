import os
import sys
import csv
from openai import OpenAI

api_key = 'sk-xyz'

def prepare_data(file_path, row_limit=100):
    """Reads the CSV file and prepares a summary of the data, limited to the first 50 rows."""
    data_lines = []
    with open(file_path, mode='r', newline='', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        for count, row in enumerate(csv_reader):
            if count >= row_limit:  # Stop after reading row_limit rows
                break
            data_lines.append(f"{row['LocalAddress']}:{row['LocalPort']} -> {row['RemoteAddress']}:{row['RemotePort']}, State: {row['State']}, Process: {row['ProcessName']}")
    return "\n".join(data_lines)

def parse_response(response):
    # Access the content directly from the nested structure
    return response.choices[0].message.content

def analyze_with_chatgpt(data):
    """Sends the prepared data to ChatGPT for analysis using the updated OpenAI API client."""
    # Initialize the OpenAI client with your API key
    client = OpenAI(api_key=api_key)
    
    try:
        response = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {
                    "role": "assistant",
                    "content": "You are a helpful network security engineer analyzing network connections for suspicious activity."
                },
                {
                    "role": "user",
                    "content": data
                }
            ],
            temperature=1,
            max_tokens=256,
            top_p=1,
            frequency_penalty=0,
            presence_penalty=0
        )
        
        # Assuming the response structure is consistent with the new pattern
        # Note: Adjust this if the actual structure differs
        # print(parse_response(response))
        return parse_response(response)
    except Exception as e:
        print(f"An error occurred while analyzing data with ChatGPT: {e}")
        return None

def main():
    data_file_path = os.path.join(os.path.expanduser('~'), 'Documents', 'CyberKombatData', 'network_info.csv')
    data = prepare_data(data_file_path)
    if data:
        report = analyze_with_chatgpt(data)
        if report:
            print("Analysis Report from ChatGPT:")
            print(report)
        else:
            print("No report was generated.")
    else:
        print("Failed to prepare data for analysis.")

if __name__ == "__main__":
    main()
