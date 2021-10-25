import csv

def learn_prior(file_name, pseudo_count=0):
    with open(file_name) as in_file:
        training_examples = [tuple(row) for row in csv.reader(in_file)]
        amount_increase = 0
        for e in training_examples:
            if e[-1] == '1':
                amount_increase += 1
    return (amount_increase + pseudo_count) / (len(training_examples) - 1 + 2 * pseudo_count)

def learn_likelihood(file_name, pseudo_count=0):
    """Takes the file name of a training set"""
    with open(file_name) as in_file:
        training_examples = [tuple(row) for row in csv.reader(in_file)]
        selections = training_examples[0]
        resourse = [[0,0] for i in range(16)]
        amount_increase = 0
        for e in training_examples:
            if e[-1] == '1':
                amount_increase += 1
            for i in range(len(e)-1):
                if e[-1] == '1' and e[i] == '1':
                    resourse[i][1] += 1
                elif e[-1] == '0' and e[i] == '1':
                    resourse[i][0] += 1
        for r in resourse:
            r[0] = (r[0] + pseudo_count) / ((len(training_examples) - amount_increase - 1) + pseudo_count * 2)
            r[1] = (r[1] + pseudo_count) / (amount_increase + pseudo_count * 2)
    return (resourse, selections)

def main():
    # Available locations
    locations = ["Auckland District", "Bay Of Plenty District", "Canterbury District", "Eastern District", "Northland District", "Tasman District", "Waikato District", "Wellington District"]
    files = ["Auckland District.csv","Bay Of Plenty District.csv","Canterbury District.csv","Eastern District.csv", "Northland District.csv", "Tasman District.csv", "Waikato District.csv","Wellington District.csv"]
    
    counter = 0
    # Print out locations
    for location in locations:
        print(f"[{counter}]: {location}")
        counter += 1
    # Select location
    selected_location = int(input("Please select one location: "))
    # AI learning and get available offence types
    likelihood, selections = learn_likelihood(files[selected_location])

    # Print out offence types
    counter = 0
    for offence_type in selections[:len(selections)-1]:
        print(f"[{counter}]: {offence_type}")
        counter += 1
    # Select offence
    selected_offence = int(input("Please select one offence type: "))
    # Specify offence happen or not
    offence_boolean_value = (input("Offence happen or not(Y/N): ")).upper() == "Y"
    # Specify Average income increase or not
    average_income_boolean_value = (input("Average income increace or not(Y/N): ")).upper() == "Y"

    # Print the information out
    if offence_boolean_value == True:
        print(f'P(({selections[selected_offence]})=TRUE | Average_Income={average_income_boolean_value}) = {likelihood[selected_offence][average_income_boolean_value]:.5f} ({locations[selected_location]})')
    else:
        print(f'P(({selections[selected_offence]})=FALSE | Average_Income={average_income_boolean_value}) = {1-likelihood[selected_offence][average_income_boolean_value]:.5f} ({locations[selected_location]})')


if __name__ == "__main__":
    main()