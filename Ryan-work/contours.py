def process_chunk(chunk:str):
    ans=chunk
    ans=ans.replace('G1','')
    ans=ans.replace('X','')
    ans=ans.replace('Y','')
    ans=line_split(ans)
    ans=[x.split() for x in ans]
    ans=[list(map(int,x)) for x in ans]
    ans=as_points_array(ans)
    return ans
def process_gcode(gcode):
    chunks=gcode.split('G0')
    chunks=[x.strip() for x in chunks]
    chunks=[printed(x) for x in chunks if x]
    chunks=[printed(process_chunk(x)) for x in chunks]
    return chunks
    
def contours_bounds(contours):
    big_contour=np.concatenate(contours)
def normalize_contours(contours):
    #Put contours in bounds from 0 to 1 by scaling them. It doesn't stretch it. Right now they're not centered.
    combined_contours=np.concatenate(contours)
    bounds=combined_contours.min(0),combined_contours.max(0)
    ranges=[a-b for a,b in bounds]
    normalized_contours=[contour-bounds[0] for contour in contours]
    normalized_contours=[contour/max(ranges) for contour in contours]
    for i in range(len(normalized_contours)):
        normalized_contours[i][:,1]=1-normalized_contours[i][:,1]
    return normalized_contours

@memoized
def image_to_contours(image):
    image_to_gcode_dir='/Users/ryan/CleanCode/Github/image-to-gcode'
    assert is_image(image) or isinstance(image,str)
    if isinstance(image,str):
        image=load_image(image,use_cache=False)
        return image_to_contours(image)
    image=resize_image_to_fit(image,width=150)
    with SetCurrentDirectoryTemporarily(image_to_gcode_dir):    
        input_file='input.png'
        output_file='out.gcode'
        save_image(image,input_file)
        os.system('python3 image_to_gcode.py -i %s -o %s'%(input_file,output_file))
        gcode=text_file_to_string(output_file)
    contours=process_gcode(gcode)
    return normalized_contours(contours)
def display_contours(contours):
    #Assumes the contours are normalized    
    display_image(contours_to_image(contours,scale=1000))
