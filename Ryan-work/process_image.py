def process_image(image):
    byte_image = as_byte_image(image)
    grayscale_image = as_grayscale_image(byte_image)
    inverted_img = inverted_image(grayscale_image)
    threshold_img = inverted_img > 10
    
    contours = cv_find_contours(threshold_img)
    contours_as_points = list(map(as_points_array, contours))
    
    height, width = get_image_dimensions(threshold_img)

    def scale_vector(path):
        path = as_points_array(path).astype(float)
        path[:, 0] /= float(height)
        path[:, 1] /= float(width)
        return path

    scaled_paths = [scale_vector(contour) for contour in contours_as_points]
    
    return scaled_paths
