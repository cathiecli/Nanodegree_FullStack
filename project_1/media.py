import webbrowser

class Movie():
    """ this class provides a way to store movie related information """

    """ function to initialize the instance """   
    def __init__(self, movie_title, movie_storyline, poster_image,
               trailer_youtube, year, genre):
        self.title = movie_title
        self.storyline = movie_storyline
        self.poster_image_url = poster_image
        self.trailer_youtube_url = trailer_youtube
        self.release_year = year
        self.genre = genre

    """ function to open movie's youtube trailer """
    def show_trailer(self):
        webbrowser.open(self.trailer_youtube_url)
