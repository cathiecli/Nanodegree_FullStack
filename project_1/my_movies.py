import fresh_tomatoes
import media

""" declare various Movie instances """
alice_wonderland = media.Movie("Alice in Wonderland",
                        "Alice Chasing after the White Rabbit",
                        "images/alice_in_wonderland_poster.jpg",
                        "https://www.youtube.com/watch?v=KOZ9wy-j9P8",
                        "1951",
                        "Animation, Kids & Family, Classics & Comedy")

finding_nemo = media.Movie("Finding Nemo",
                        "The story of a fish Nemo",
                        "images/finding_nemo_poster.jpg",
                        "https://www.youtube.com/watch?v=wZdpNglLbt8",
                        "2003",
                        "Animation, Kids & Family, Comedy")

frozen = media.Movie("Frozen",
                        "The story of Elsa, the Snow Queen, and her sister Anna",
                        "images/frozen_poster.jpg",
                        "https://www.youtube.com/watch?v=TbQm5doF_Uc",
                        "2010",
                        "Animation, Kids & Family")

ice_age = media.Movie("Ice Age",
                        "A world filled with wonder and danger",
                        "images/ice_age_4_poster.jpg",
                        "https://www.youtube.com/watch?v=ja-qjGeDBZQ",
                        "2002",
                        "Animation, Kids & Family, Comedy")

ratatouille = media.Movie("Ratatouille",
                         "A rat is a chef in Paris",
                         "images/ratatouille_poster.jpg",
                         "https://www.youtube.com/watch?v=c3sBBRxDAqk",
                         "2007",
                         "Animation, Kids & Family, Comedy")

peabody_sherman = media.Movie("Mr. Peabody & Sherman",
                        "Mr. Peabody, the most accomplished dog in the world, and his mischievous boy Sherman",
                        "images/mr_peabody_and_sherman_poster.jpg",
                        "https://www.youtube.com/watch?v=TEHWDA_6e3M",
                        "2014",
                        "Action & Adventure, Animation, Kids & Family, Comedy")

""" assign Movie instances into a list """
movies = [alice_wonderland, finding_nemo, frozen, ice_age, ratatouille, peabody_sherman]
""" send movies list to fresh_tomatoes to open the movie page """
fresh_tomatoes.open_movies_page(movies)
