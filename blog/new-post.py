"""
This script takes a title as a cli argument, and creates a new markdown file in the posts directory with the title as the file name, and adds it to posts.json.
"""

import datetime
import json
import os
import sys
from pathlib import Path


BLOG_DIR = Path(__file__).parent.resolve()
JSON_FILE_PATH = BLOG_DIR / "posts.json"
POSTS_DIR = BLOG_DIR / "posts"


def error(msg):
    """Prints an error message and exits the program"""
    print(msg, file=sys.stderr)
    sys.exit(1)


def parse_args():
    """Parses the command line arguments and returns the title"""
    if len(sys.argv) < 2:
        error("""
Usage:
    python new-post.py "<title>"
        """.strip())
    return sys.argv[1]


def generate_json_obj(title, file_name):
    now = datetime.datetime.now()
    obj = {
        "title": title,
        "date": now.strftime("%Y-%m-%d"),
        "fileName": file_name.replace(".html", ""),
    }
    return obj


def add_to_posts_json(obj):
    lines_to_add = json.dumps(obj, indent=4).splitlines()
    # Add a comma to the last line
    lines_to_add[-1] = lines_to_add[-1] + ","
    # Indent all lines
    lines_to_add = ["    " + line for line in lines_to_add]
    # Add linebreaks
    lines_to_add = [line + "\n" for line in lines_to_add]

    with open(JSON_FILE_PATH, "r+") as file:
        lines = file.readlines()
        # Place the lines to add directly after the first line.
        lines = lines[:1] + lines_to_add + lines[1:]
        file.seek(0)
        file.writelines(lines)


def create_new_post_file(file_path):
    # For now just create an empty file
    with open(file_path, "w") as _:
        pass


def str_to_filename(s: str) -> str:
    return ''.join(c if c.isalnum() else '-' for c in s).lower() + '.html'


def main():
    title = parse_args()
    file_name = str_to_filename(title)
    file_path = os.path.join(POSTS_DIR, file_name)

    if os.path.exists(file_path):
        error("File already exists")

    json_obj = generate_json_obj(title, file_name)
    add_to_posts_json(json_obj)
    create_new_post_file(file_path)
    print(f"Added new post to {JSON_FILE_PATH} at path {file_path}")


if __name__ == "__main__":
    main()
