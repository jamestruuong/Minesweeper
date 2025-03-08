import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i<NUM_ROWS;i++){
      for(int x = 0; x<NUM_COLS; x++){
        buttons[i][x] = new MSButton(i,x);
      }
    }
    
    
    
    setMines();
}
public void setMines()
{
    int mineNumber = 0;
    while(mineNumber < NUM_ROWS + NUM_COLS){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
      mineNumber++;
    }  
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
                return false; 
            }
        }
    }
    return true; 
}
public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i++) {  
        MSButton mine = mines.get(i);
        mine.setLabel(":(");  // Mark all mines with "M"
        mine.clicked = true;
    }
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c])) {
                buttons[r][c].setLabel("X");
            }
        }
    }
}
public void displayWinningMessage()
{
     for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel("YAY");
        }
    }
}
public boolean isValid(int r, int c)
{
    if((NUM_ROWS>r&&r>=0)&&(NUM_COLS>c&&c>=0)){
    return true;
  }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = -1; r<=1; r++){
      for(int c = -1; c<=1; c++){
        int newRow = row + r;
        int newCol = col + c;
        if(!(r == 0 & c == 0)){
       if(isValid(newRow,newCol) && mines.contains(buttons[newRow][newCol])){
         numMines++;
       }
      }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;  
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == false){
          flagged = true;
         
          }
        else if(flagged == true) {
         flagged = false;
         clicked = false;
         }
        }
        else if(mines.contains(this)) {
          displayLosingMessage();
          } else if (countMines(myRow,myCol)>0) {
          setLabel(countMines(myRow,myCol));
        } else {
    for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
            if (isValid(r, c) && !buttons[r][c].clicked) {
                buttons[r][c].mousePressed();
            }
        } 
    }
} 
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
