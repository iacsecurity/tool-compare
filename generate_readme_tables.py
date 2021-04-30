import os
import json


tools = {
    "checkov": "Checkov",
    "cloudrail": "Indeni Cloudrail",
    "kics": "Kics",
    "snyk": "Snyk",
    "terrascan": "Terrascan",
    "tfsec": "Tfsec"
}


def recurse_dir(path, level):
    heading_prefix = '#' * level
    print(f'{heading_prefix} {os.path.basename(path)}')

    found_sub_categories = False
    for subdir in sorted(os.listdir(path)):
        if os.path.isdir(os.path.join(path, subdir)) and not os.path.exists(os.path.join(path, subdir, "main.tf")):
            found_sub_categories = True
            recurse_dir(os.path.join(path, subdir), level + 1)

    if not found_sub_categories:
        print_category_test_case_table(path)


def print_category_test_case_table(path):
    header = "| Test Case |"
    header_line = "|----|"
    for tool in tools.values():
        header += f" {tool} |"
        header_line += "----|"
    print(header)
    print(header_line)
    for subdir in sorted(os.listdir(path)):
        summary_json_path = os.path.join(path, subdir, "results_summary.json")
        if os.path.exists(summary_json_path):
            with open(summary_json_path) as summary_json_file:
                summary_json = json.load(summary_json_file)
                case_line = f"|[{subdir}]({os.path.join(path, subdir)})|"
                for tool in tools:
                    case_line += (':white_check_mark:' if summary_json[tool] == 'yes' else ':x:') + "|"
                print(case_line)


if __name__ == "__main__":
    recurse_dir("test-cases", 2)
