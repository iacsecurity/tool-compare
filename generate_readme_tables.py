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


def recurse_dir(path, level, total_case_catch_stats, is_root):
    results = ""

    heading_prefix = '#' * level
    if not is_root:
        results += f'{heading_prefix} {os.path.basename(path)}\n'

    found_sub_categories = False
    for subdir in sorted(os.listdir(path)):
        if os.path.isdir(os.path.join(path, subdir)) and not os.path.exists(os.path.join(path, subdir, "main.tf")):
            found_sub_categories = True
            results += recurse_dir(os.path.join(path, subdir), level + 1, total_case_catch_stats, is_root = False)

    if not found_sub_categories:
        results += print_category_test_case_table(path, total_case_catch_stats)

    return results

def print_category_test_case_table(path, total_case_catch_stats):
    results = ""
    category_catch_summary = {x: 0 for x in tools.keys()}
    category_catch_summary['total'] = 0

    header = "| Test Case |"
    header_line = "|----|"
    for tool in tools.values():
        header += f" {tool} |"
        header_line += "----|"
    results += f"{header}\n"
    results += f"{header_line}\n"
    for subdir in sorted(os.listdir(path)):

        summary_json_path = os.path.join(path, subdir, "results_summary.json")
        if os.path.exists(summary_json_path):
            category_catch_summary['total'] += 1
            total_case_catch_stats['total'] += 1

            with open(summary_json_path) as summary_json_file:
                summary_json = json.load(summary_json_file)
                case_line = f"|[{subdir}]({os.path.join(path, subdir)})|"
                for tool in tools:
                    case_line += (':white_check_mark:' if summary_json[tool] == 'yes' else ':x:') + "|"
                    category_catch_summary[tool] += 1 if summary_json[tool] == 'yes' else 0
                    total_case_catch_stats[tool] += 1 if summary_json[tool] == 'yes' else 0

                results += f"{case_line}\n"

    summary_line = f"|Category Catch Rate|"
    for tool in tools:
        summary_line += f"{round(category_catch_summary[tool] * 100 / category_catch_summary['total'])}%|"
    results += f"{summary_line}\n"

    return results


if __name__ == "__main__":
    total_case_catch_stats = {x: 0 for x in tools.keys()}
    total_case_catch_stats['total'] = 0

    full_results = recurse_dir("test-cases", 2, total_case_catch_stats, is_root = True)

    header = "|     |"
    header_line = "|----|"
    for tool in tools.values():
        header += f" {tool} |"
        header_line += "----|"
    print("### Summary")
    print(header)
    print(header_line)

    summary_line = f"|Total Catch Rate|"
    for tool in tools:
        summary_line += f"{round(total_case_catch_stats[tool] * 100 / total_case_catch_stats['total'])}%|"
    print(summary_line)

    print(full_results)
