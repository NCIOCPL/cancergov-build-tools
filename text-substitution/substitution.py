import argparse

import xml.etree.ElementTree as ET

# Build a list of tuples with the first value being the text to find
# and the second value being the replacement.
def loadSubstitutions(substFile):
    # Create element tree object
    tree = ET.parse(substFile)

    root = tree.getroot()

    # Create empty list
    substitutions = []

    for node in root.findall('substitute'):
        f = node.find('find').text
        r = node.find('replacement').text
        substitutions.append((f,r))

    return substitutions


# Perform text substitutions.
def performSubstitution(inputText, substitutions):
    text = inputText

    # Placeholders appear in the input text, with a leading dollar sign ($)
    # and surrounded by curly braces.  So to replace 'PLACEHOLDER', search
    # for '${PLACEHOLDER}'
    for pair in substitutions:
        placeholder = '${{{0}}}'.format(pair[0])
        text = text.replace(placeholder, pair[1])

    return text


def main():
    parser = argparse.ArgumentParser(description='Simple text substitution tool.')
    parser.add_argument('-inputfile', action='store', required=True)
    parser.add_argument('-outputfile', action='store', required=True)
    parser.add_argument('-substitutelist', action='store', required=True)
    args = parser.parse_args()

    substitutions = loadSubstitutions(args.substitutelist)
    
    # Load the file which the substitutions will be inserted into
    fi = open(args.inputfile, 'r')
    inputData = fi.read()
    fi.close()

    replacement = performSubstitution(inputData, substitutions)

    # Save the processed text
    fo = open(args.outputfile, 'w')
    fo.write(replacement)
    fo.close()


if __name__ == "__main__":
    main()
