# -*- coding: utf-8 -*-

import pygame
from pygame.locals import *
from sys import exit
import os
import sys


from config import CurKeySet


def GetButtonsLayoutMode():
    lm = "xbox"
    try:
        with open(".buttonslayout", "r") as f:
            lm = f.read()
    except:
        None
    if lm not in ["xbox","snes"]:
        lm = "xbox"
    return lm

def SetButtonsLayoutMode(mode):
    SetXYABButtons(mode)
    with open(".buttonslayout", "w") as f:
        f.write(mode)

def SetXYABButtons(mode):
    if mode == "snes":
        GameShell["Y"] = pygame.K_7
        GameShell["X"] = pygame.K_9
        GameShell["B"] = pygame.K_8
        GameShell["A"] = pygame.K_0
    else:
        GameShell["X"] = pygame.K_7
        GameShell["Y"] = pygame.K_9
        GameShell["A"] = pygame.K_8
        GameShell["B"] = pygame.K_0


GameShell = {}
GameShell["Up"]   = pygame.K_UP
GameShell["Down"] = pygame.K_DOWN
GameShell["Left"] = pygame.K_LEFT
GameShell["Right"]= pygame.K_RIGHT

GameShell["Menu"] = pygame.K_ESCAPE

SetXYABButtons(GetButtonsLayoutMode())

GameShell["Select"] = pygame.K_RSHIFT
GameShell["Start"] = pygame.K_RETURN

GameShell["LK1"] = pygame.K_h
GameShell["LK5"] = pygame.K_l

PC = {}

PC["Up"]    = pygame.K_UP
PC["Down"]  = pygame.K_DOWN
PC["Left"]  = pygame.K_LEFT
PC["Right"] = pygame.K_RIGHT
PC["Menu"]  = pygame.K_ESCAPE

PC["X"]     = pygame.K_7
PC["Y"]     = pygame.K_9
PC["A"]     = pygame.K_8
PC["B"]     = pygame.K_0
PC["Select"] = pygame.K_RSHIFT
PC["Start"] = pygame.K_RETURN

PC["LK1"] = pygame.K_h
PC["LK5"] = pygame.K_l

if CurKeySet == "PC":
    CurKeys = PC
else:
    CurKeys = GameShell


def IsKeyStartOrA(key):
    return key == CurKeys["Start"] or key == CurKeys["A"]

def IsKeyMenuOrB(key):
    return key == CurKeys["Menu"] or key == CurKeys["B"]
