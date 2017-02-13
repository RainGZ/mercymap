//
//  LightAddreCell.m
//  MercyMap
//
//  Created by sunshaoxun on 16/9/21.
//  Copyright © 2016年 Wispeed. All rights reserved.
//

#import "LightAddreCell.h"
#import "Masonry.h"
@implementation LightAddreCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.addreBtn];
        [self.contentView addSubview:self.addreText];
        [self.contentView addSubview:self.cellSepter];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.cellSepter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(1);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(1);
        make.height.mas_equalTo(1);
    }];
    [self.addreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo (self.contentView).offset(15);
    make.size.mas_equalTo(CGSizeMake(20, 20));
    make.top.mas_equalTo (self.contentView).offset(10);
    }];
    [self.addreText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.addreBtn.mas_centerY);
        make.top.mas_equalTo (self.contentView).offset(10);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.addreBtn.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
}

-(void)configData:(id)data{
    
}
-(UIButton *)addreBtn{
    if (_addreBtn == nil ) {
        _addreBtn = [UIButton buttonWithType:0];
    }
    return _addreBtn;
}
-(UILabel *)addreText{
    if (_addreText == nil) {
        _addreText = [[UILabel alloc]init];
        _addreText.font = [UIFont systemFontOfSize:14];
    }
    return _addreText;
}
-(UILabel *)cellSepter{
    if (_cellSepter == nil) {
        _cellSepter = [[UILabel alloc]init];
        _cellSepter.backgroundColor = [UIColor lightGrayColor ];
    }
    return _cellSepter;
}
@end
