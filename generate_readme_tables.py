import os
import json
from datetime import datetime

tools = {
    "checkov": "Checkov",
    "cloudrail": "Indeni Cloudrail",
    "kics": "Kics",
    "snyk": "Snyk",
    "terrascan": "Terrascan",
    "tfsec": "Tfsec"
}


def recurse_dir(path, top_level_category_name, total_case_catch_stats, top_level_category_stats, is_root):
    results = ""

    found_sub_categories = False
    for subdir in sorted(os.listdir(path)):
        if os.path.isdir(os.path.join(path, subdir)) and not os.path.exists(os.path.join(path, subdir, "main.tf")) and not subdir == ".terraform":
            found_sub_categories = True

            results += recurse_dir(os.path.join(path, subdir), top_level_category_name, total_case_catch_stats, top_level_category_stats, is_root = False)

    if not found_sub_categories:
        results += "<details>"
        results += f'<summary>{path}</summary>\n\n'
        results += generate_sub_category_test_case_table(path, top_level_category_name, total_case_catch_stats, top_level_category_stats)
        results += "</details>\n\n"


    return results

def generate_sub_category_test_case_table(path, top_level_category_name, total_case_catch_stats, top_level_category_stats):
    results = ""
    sub_category_catch_summary = {x: 0 for x in tools.keys()}
    sub_category_catch_summary['total'] = 0

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
            sub_category_catch_summary['total'] += 1
            total_case_catch_stats['total'] += 1
            top_level_category['total'] += 1

            with open(summary_json_path) as summary_json_file:
                summary_json = json.load(summary_json_file)
                adjusted_case_name = (subdir[:40] + '..') if len(subdir) > 40 else subdir
                case_line = f"|[{adjusted_case_name}]({os.path.join(path, subdir)})|"

                for tool in tools:
                    case_line += (':white_check_mark:' if summary_json[tool] == 'yes' else ':x:') + "|"
                    sub_category_catch_summary[tool] += 1 if summary_json[tool] == 'yes' else 0
                    total_case_catch_stats[tool] += 1 if summary_json[tool] == 'yes' else 0
                    top_level_category[tool] += 1 if summary_json[tool] == 'yes' else 0

                results += f"{case_line}\n"

    summary_line = f"|Sub-category Catch Rate|"
    for tool in tools:
        if sub_category_catch_summary['total'] > 0:
            summary_line += f"{round(sub_category_catch_summary[tool] * 100 / sub_category_catch_summary['total'])}%|"
    results += f"{summary_line}\n\n"

    return results


def generate_summary_table():
    header = "|     |"
    header_line = "|----|"
    for tool in tools.values():
        header += f" {tool} |"
        header_line += "----|"

    results = f"### Summary\n"
    results += f"Last update: {datetime.today().strftime('%Y-%m-%d')}\n\n"
    results += f"{header}\n"
    results += f"{header_line}\n"

    version_line = f"|Tested Version|"
    for tool in tools:
        with open(f"version_{tool}.txt") as fp:
            tool_version = fp.readline().strip().replace("v", "")
            version_line += f"{tool_version}|"
    results += f"{version_line}\n"

    for top_level_category in top_level_categories_cash_catch_stats["categories"]:
        top_level_category_line = f"""|{top_level_category["name"]}|"""
        for tool in tools:
            top_level_category_line += f"""{round(top_level_category[tool] * 100 / top_level_category["total"])}%|"""
        results += f"{top_level_category_line}\n"


    summary_line = f"|Total Catch Rate|"
    for tool in tools:
        summary_line += f"{round(total_case_catch_stats[tool] * 100 / total_case_catch_stats['total'])}%|"
    results += f"{summary_line}\n"

    return results


if __name__ == "__main__":
    total_case_catch_stats = {x: 0 for x in tools.keys()}
    total_case_catch_stats['total'] = 0

    top_level_categories_cash_catch_stats = {
        "categories": [
            {"name": "Terraform - AWS", "path": "test-cases/terraform/aws"},
            {"name": "Terraform - Azure", "path": "test-cases/terraform/azure"},
            {"name": "Terraform - Advanced Language Expressions", "path": "test-cases/terraform/hcl_language_complexity"}
        ]
    }

    full_results = ""
    for top_level_category in top_level_categories_cash_catch_stats["categories"]:
        top_level_category['total'] = 0
        for tool in tools.keys():
            top_level_category[tool] = 0

        full_results += recurse_dir(top_level_category['path'], top_level_category['name'], total_case_catch_stats, top_level_category, is_root = True)
 
    summary_table = generate_summary_table()

    with open("resources/README.md.template", "r") as fr:
        template = fr.read()

    template = template.replace("{{ summary_table }}", summary_table)
    template = template.replace("{{ full_results }}", full_results)
    print(template)
