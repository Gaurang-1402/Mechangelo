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
