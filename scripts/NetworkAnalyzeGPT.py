# main.py
from utils import prepare_data, analyze_with_chatgpt
from config import data_file_path

def main():
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
