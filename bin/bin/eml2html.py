#!/usr/bin/env python3

import click
import os
import email
from email import policy
from pathlib import Path
from bs4 import BeautifulSoup

@click.command()
@click.argument('eml_file', type=click.Path(exists=True))
@click.option('--outdir', '-o', default='.', type=click.Path(), help='Directory to save .html file')
@click.option('--strip-td', is_flag=True, help='Strip <td style="padding:0 10px"> elements from HTML')
def convert_eml_to_html(eml_file, outdir, strip_td):
    """
    Convert a .eml email file to .html (if HTML body exists).
    """
    with open(eml_file, 'rb') as f:
        msg = email.message_from_binary_file(f, policy=policy.default)

    html_body = None
    for part in msg.walk():
        if part.get_content_type() == "text/html":
            html_body = part.get_content()
            break

    if not html_body:
        click.echo("No HTML body found in this email.")
        return

    if strip_td:
        soup = BeautifulSoup(html_body, 'html.parser')
        targets = soup.select('td[style="padding:0 10px"]')
        for tag in targets:
            tag.decompose()
        html_body = str(soup)

    eml_path = Path(eml_file)
    output_path = Path(outdir) / eml_path.with_suffix('.html').name

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html_body)

    click.echo(f"HTML saved to: {output_path}")

if __name__ == '__main__':
    convert_eml_to_html()

