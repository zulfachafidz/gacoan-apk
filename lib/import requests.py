import requests
# Define the base URL for the food delivery API.
BASE_URL = "https://api.fooddelivery.com/v1/"
# Define the headers for the API requests.
HEADERS = {
    "Authorization": "Bearer YOUR_API_KEY",
    "Content-Type": "application/json",
}
# Define the function to get the list of restaurants.
def get_restaurants():
  """Gets the list of restaurants from the API.
  Returns:
    A list of dictionaries, where each dictionary represents a restaurant.
  """
  # Make a GET request to the /restaurants endpoint.
  response = requests.get(BASE_URL + "restaurants", headers=HEADERS)
  # Check if the request was successful.
  if response.status_code == 200:
    # The request was successful, so parse the response body.
    restaurants = response.json()
    return restaurants
  else:
    # The request failed, so raise an exception.
    raise Exception("Failed to get restaurants: {}".format(response.status_code))
# Define the function to get the menu for a restaurant.
def get_menu(restaurant_id):
  """Gets the menu for a restaurant from the API.
  Args:
    restaurant_id: The ID of the restaurant.
  Returns:
    A list of dictionaries, where each dictionary represents a menu item.
  """
  # Make a GET request to the /restaurants/{restaurant_id}/menu endpoint.
  response = requests.get(
      BASE_URL + "restaurants/{}/menu".format(restaurant_id), headers=HEADERS)
  # Check if the request was successful.
  if response.status_code == 200:
    # The request was successful, so parse the response body.
    menu = response.json()
    return menu
  else:
    # The request failed, so raise an exception.
    raise Exception("Failed to get menu: {}".format(response.status_code))