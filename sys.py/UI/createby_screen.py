import pygame
import os

from full_screen import FullScreen
from skin_manager import MySkinManager
from constants   import Width,Height

class CreateByScreen(FullScreen):
    _BG = None
    _BGColor = MySkinManager.GiveColor('Black')
    
    def Init(self):
        basepath = os.path.dirname(os.path.realpath(__file__))
        self._BG = pygame.image.load(basepath+"/egg.png")
        self._CanvasHWND = pygame.Surface((self._Width,self._Height))
        
    def Draw(self):
        self._CanvasHWND.fill( self._BGColor )
        self._CanvasHWND.blit(self._BG,(0,0,Width,Height))
