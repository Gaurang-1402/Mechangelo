import numpy as np

def process_chunk(chunk: str):
    # Remove G1, X, and Y commands from the chunk
    cleaned_chunk = chunk.replace('G1', '').replace('X', '').replace('Y', '')
    
    # Split the cleaned chunk into lines
    lines = cleaned_chunk.splitlines()
    
    # Split each line into coordinate pairs (strings)
    coordinate_pairs = [line.split() for line in lines]
    
    # Convert coordinate pairs from strings to integers
    int_coordinates = [list(map(int, pair)) for pair in coordinate_pairs]
    
    # Convert the list of integer coordinates into a NumPy array
    points_array = np.array(int_coordinates)
    
    return points_array

def process_gcode(gcode):
    # Split the gcode into chunks using 'G0' as a delimiter
    chunks = gcode.split('G0')
    
    # Remove leading and trailing whitespace from each chunk
    cleaned_chunks = [chunk.strip() for chunk in chunks]
    
    # Filter out empty chunks
    non_empty_chunks = [chunk for chunk in cleaned_chunks if chunk]
    
    # Process each non-empty chunk and convert it into a list of points
    processed_chunks = [process_chunk(chunk) for chunk in non_empty_chunks]
    
    return processed_chunks


@memoized
def image_to_contours(image):
    # Set the path to the image-to-gcode directory
    image_to_gcode_dir = '/Users/ryan/CleanCode/Github/image-to-gcode'
    
    # Check if the input is a valid image or a string (file path)
    assert is_image(image) or isinstance(image, str)
    
    # If the input is a string (file path), load the image and call the function again
    if isinstance(image, str):
        image = load_image(image, use_cache=False)
        return image_to_contours(image)
    
    # Resize the image to fit within the specified width
    resized_image = resize_image_to_fit(image, width=150)
    
    # Change the current directory temporarily to the image-to-gcode directory
    with SetCurrentDirectoryTemporarily(image_to_gcode_dir):
        input_file = 'input.png'
        output_file = 'out.gcode'
        
        # Save the resized image as input_file
        save_image(resized_image, input_file)
        
        # Run the image-to-gcode script using the input_file and save the result as output_file
        os.system('python3 image_to_gcode.py -i %s -o %s' % (input_file, output_file))
        
        # Read the contents of the output_file as a string
        gcode = text_file_to_string(output_file)
    
    # Process the gcode and obtain the contours
    contours = process_gcode(gcode)
    
    # Normalize the contours and return the result
    return normalize_contours(contours)


def contours_bounds(contours):
    big_contour=np.concatenate(contours)
    
def normalize_contours(contours):
    #Put contours in bounds from 0 to 1 by scaling them. It doesn't stretch it. Right now they're not centered.
    combined_contours=np.concatenate(contours)
    bounds=combined_contours.min(0),combined_contours.max(0)
    ranges=[a-b for a,b in bounds]
    normalized_contours=[contour-bounds[0] for contour in contours]
    normalized_contours=[contour/max(ranges) for contour in normalized_contours]
    for i in range(len(normalized_contours)):
        normalized_contours[i][:,1]=1-normalized_contours[i][:,1]
    return normalized_contours


