from tabulate import tabulate

import yaml
import glob
import os

with open('capabilities/regula.yaml') as f:
    tool = yaml.safe_load(f)
with open('./capabilities/capabilities.md.tpl') as f:
    template = f.read()

current_dir = os.path.dirname(os.path.realpath(__file__))
tools = []
for tool_file in glob.glob(current_dir + '/*.yaml'):
    with open(tool_file) as f:
        tools.append(yaml.safe_load(f.read()))


def make_link(address, text=''):
    text = text if text != '' else address
    return f'<a href="{address}">{text}</a>'

def generate_overview_data(tools):
    headers = [
        ""
        "License",
        "Maintainer",
        "Website",
        "Requires registration?"
    ]
    data = []
    for tool in tools:
        metadata = tool['metadata']
        data.append([
            f"<b>{metadata['name']}",
            metadata['license'],
            metadata['maintainer'],
            make_link(metadata['links']['website'], metadata['links']['website'].replace('https://', '')),
            'Yes' if metadata['requiresRegistration'] else 'No'
        ])

    return tabulate(data, headers, tablefmt="unsafehtml")


def generate_iac_language_support_table(tools):
    headers = [
        ""
        "Terraform HCL",
        "Terraform plan",
        "CloudFormation",
        "Pulumi"
    ]
    data = []
    for tool in tools:
        data.append([
            f"<b>{tool['metadata']['name']}",
            ':white_check_mark:' if 'terraform' in tool['capabilities'][
                'languageSupport'] else ':x:',
            ':white_check_mark:' if 'terraform-plan' in tool['capabilities'][
                'languageSupport'] else ':x:',
            ':white_check_mark:' if 'cloudformation' in tool['capabilities'][
                'languageSupport'] else ':x:',
            ':white_check_mark:' if 'pulumi' in tool['capabilities']['languageSupport'] else ':x:',
        ])
    return tabulate(data, headers, tablefmt="unsafehtml")


def generate_cloud_provider_support_table(tools):
    headers = [
        ""
        "AWS",
        "Azure",
        "GCP"
    ]
    data = []
    for tool in tools:
        data.append([
            f"<b>{tool['metadata']['name']}",
            ':white_check_mark:' if 'aws' in tool['capabilities']['providerSupport'] else ':x:',
            ':white_check_mark:' if 'azure' in tool['capabilities']['providerSupport'] else ':x:',
            ':white_check_mark:' if 'gcp' in tool['capabilities']['providerSupport'] else ':x:'])
    return tabulate(data, headers, tablefmt="unsafehtml")

def generate_custom_rules_table(tools):
    headers = [
        "",
        "Language",
        "Multi-resource correlation",
        "Correlation with runtime resources",
        "Out-of-the-box support for unit tests"
    ]
    data = []
    for tool in tools:
        props = tool['capabilities']['customRules']
        data.append([
            f"<b>{tool['metadata']['name']}",
            props.get('language', 'N/A (unsupported)'),
            ':white_check_mark:' if props.get('supportsMultiResourceCorrelation') else ':x:',
            ':white_check_mark:' if props.get('supportsRuntimeIacCorrelation') else ':x:',
            ':white_check_mark:' if props.get('supportsUnitTests') else ':x:'
        ])
    return tabulate(data, headers, tablefmt="unsafehtml")



def generate_scan_output_table(tools):
    headers = [
        "",
        "Supported output formats",
        "Shows offending file names",
        "Shows offending line numbers"
    ]
    data = []
    for tool in tools:
        props = tool['capabilities']['output']
        data.append([
            f"<b>{tool['metadata']['name']}",
            ", ".join(props['formats']),
            ':white_check_mark:' if props['showsFilenames'] else ':x:',
            ':white_check_mark:' if props['showsLineNumbers'] else ':x:'
        ])
    return tabulate(data, headers, tablefmt="unsafehtml")


output = template.replace('%{overview_table}', generate_overview_data(tools)) \
    .replace('%{language_support_table}', generate_iac_language_support_table(tools)) \
    .replace('%{cloud_provider_support_table}', generate_cloud_provider_support_table(tools)) \
    .replace('%{custom_rules_table}', generate_custom_rules_table(tools)) \
    .replace('%{scan_output_table}', generate_scan_output_table(tools))


print(output)
