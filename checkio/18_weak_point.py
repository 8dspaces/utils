def weak_point(matrix):
    rows = []
    columns = []
    for i in range(len(matrix)):
        rows.append(sum(matrix[i]))
        t = 0
        for j in range(len(matrix)):
            t += matrix[j][i]
        columns.append(t)
        
    return [rows.index(min(rows)),columns.index(min(columns))]
# reference 

def weak_point_2(matrix):
    n = len(matrix)
    row = min(range(n), key=lambda r:sum(matrix[r][c] for c in range(n)))
    col = min(range(n), key=lambda c:sum(matrix[r][c] for r in range(n)))
    return row, col

def weak_point_3(matrix):
    rows, cols = map(sum, matrix), map(sum, zip(*matrix))
    return rows.index(min(rows)), cols.index(min(cols))
    
    
if __name__ == '__main__':
    assert weak_point([[7, 2, 7, 2, 8],
                      [2, 9, 4, 1, 7],
                      [3, 8, 6, 2, 4],
                      [2, 5, 2, 9, 1],
                      [6, 6, 5, 4, 5]]) == [3, 3]
    assert weak_point([[7, 2, 4, 2, 8],
                      [2, 8, 1, 1, 7],
                      [3, 8, 6, 2, 4],
                      [2, 5, 2, 9, 1],
                      [6, 6, 5, 4, 5]]) == [1, 2]
                