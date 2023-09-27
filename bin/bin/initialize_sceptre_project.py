#!/usr/bin/env python3
import os
import click
import configparser

@click.command()
@click.option('--name', prompt='Enter the project name', help='The name of the project')
@click.option('--description', prompt='Enter a short description', help='A short description of the project')
@click.option('--stacks', prompt='Enter a comma-separated list of stack names', help='A comma-separated list of stack names')
def create_project_structure(name, description, stacks):
    stacks = [stack.strip() for stack in stacks.split(",")]

    # Create the project directory
    os.makedirs(name)
    os.chdir(name)

    # Create config directory
    os.makedirs("config/env")
    os.makedirs("config/stacks")
    os.makedirs("config/templates")

    # Create hooks and plugins directories
    os.makedirs("hooks")
    os.makedirs("plugins")

    # Create README.md
    with open("README.md", "w") as readme_file:
        readme_file.write(f"# {name}\n\n")
        readme_file.write(f"{description}\n\n")
        readme_file.write("## Stacks\n")
        for stack in stacks:
            readme_file.write(f"- {stack}\n")

    # Determine the default region
    default_region = get_default_region()

    # Create main config file
    main_config = f"""---
project_code: {name}
region: {default_region}
template_bucket_name: {name}-templates-bucket
stack_group: {name}-stack-group
"""
    with open("config/config.yaml", "w") as config_file:
        config_file.write(main_config)

    # Create stack configuration files
    for stack in stacks:
        stack_config = f"""---
template_path: config/templates/{stack}
parameters: {{}}
"""
        with open(f"config/stacks/{stack}.yaml", "w") as stack_file:
            stack_file.write(stack_config)

    # Create environment configuration files (dev, stg, prd)
    environments = ['dev', 'stg', 'prd']
    for env in environments:
        env_config = f"""---
region: {default_region}
# Add environment-specific configurations here
"""
        with open(f"config/env/{env}.yaml", "w") as env_file:
            env_file.write(env_config)

    # Create template folders and stub templates
    for stack in stacks:
        os.makedirs(f"config/templates/{stack}")
        stub_template = f"""Resources:
  # Define your CloudFormation resources here
"""
        with open(f"config/templates/{stack}/{stack}_template.yaml", "w") as template_file:
            template_file.write(stub_template)

    click.echo(f"Project structure for '{name}' has been created.")

def get_default_region():
    # Attempt to read the default region from ~/.aws/config
    try:
        aws_config = configparser.ConfigParser()
        aws_config.read(os.path.expanduser("~/.aws/config"))
        return aws_config.get('default', 'region', fallback='us-west-2')
    except (configparser.NoSectionError, configparser.NoOptionError):
        return 'us-west-2'

if __name__ == "__main__":
    create_project_structure()

