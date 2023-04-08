'''
Author: WengMixin mixin_weng2022@163.com
Date: 2023-01-15 18:52:12
LastEditors: WengMixin mixin_weng2022@163.com
LastEditTime: 2023-01-15 19:07:38
FilePath: \cs61a\projects\hog\hog_contest\final_strategy.py
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
'''
"""
    This file contains your final_strategy that will be submitted to the contest.
    It will only be run on your local machine, so you can import whatever you want!
    Remember to supply a unique PLAYER_NAME or your submission will not succeed.
"""

PLAYER_NAME = 'Max'  # Change this line!


def final_strategy(score, opponent_score):
    def is_swap(sc,opp_sc):
        dif = abs(sc%10 - opp_sc%10)
        if dif == opp_sc//10%10:#//这个10%10的操作，可以保证找到的是十位数。
            return True
        else:
            return False

    def free_bacon():
        return 10 + (opponent_score//10 - opponent_score%10)

    def swap_strategy(num_rolls,cutoff):
        get_score = score + free_bacon()
        if is_swap(get_score,opponent_score):
            if get_score<opponent_score:
                return 0    
            else:
                return num_rolls
        else: 
            if free_bacon() >= cutoff:
                return 0
            else:
                return num_rolls 

    if is_swap(score+1,opponent_score) and opponent_score>score+4:
        if opponent_score-score > 20:
            return 10
        elif opponent_score-score > 14:
            return 9
        else: 
            return 8
    else:
        return swap_strategy(6,7)