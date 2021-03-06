#import "CommentCell.h"
#import "GHComment.h"
#import "NSDate+Nibware.h"
#import "GHUser.h"
#import "TTTAttributedLabel.h"



@interface CommentCell () <TTTAttributedLabelDelegate>
@property(nonatomic,weak)IBOutlet UIButton *gravatarButton;
@property(nonatomic,weak)IBOutlet UIButton *userButton;
@property(nonatomic,weak)IBOutlet UILabel *dateLabel;
@end


@implementation CommentCell

static NSString *const UserGravatarKeyPath = @"user.gravatar";

- (void)awakeFromNib {
    [super awakeFromNib];
    self.linksEnabled = YES;
    self.emojiEnabled = YES;
    self.markdownEnabled = YES;
    self.gravatarButton.layer.cornerRadius = 3;
    self.gravatarButton.layer.masksToBounds = YES;
}

- (void)dealloc {
	[self.comment removeObserver:self forKeyPath:UserGravatarKeyPath];
}

- (void)setComment:(GHComment *)comment {
	[self.comment removeObserver:self forKeyPath:UserGravatarKeyPath];
	_comment = comment;
    [self.comment addObserver:self forKeyPath:UserGravatarKeyPath options:NSKeyValueObservingOptionNew context:nil];
	self.dateLabel.text = self.comment.createdAt.prettyDate;
	self.contentText = self.comment.body;
	self.userLogin = self.comment.user.login;
	self.gravatar = self.comment.user.gravatar ? self.comment.user.gravatar : [UIImage imageNamed:@"AvatarBackground32.png"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:UserGravatarKeyPath] && self.comment.user.gravatar) {
		self.gravatar = self.comment.user.gravatar;
	}
}

#pragma mark Helpers

- (void)setGravatar:(UIImage *)gravatar {
    [self.gravatarButton setImage:gravatar forState:UIControlStateNormal];
    [self.gravatarButton setImage:gravatar forState:UIControlStateHighlighted];
    [self.gravatarButton setImage:gravatar forState:UIControlStateSelected];
    [self.gravatarButton setImage:gravatar forState:UIControlStateDisabled];
}

- (void)setUserLogin:(NSString *)login {
    [self.userButton setTitle:login forState:UIControlStateNormal];
    [self.userButton setTitle:login forState:UIControlStateHighlighted];
    [self.userButton setTitle:login forState:UIControlStateSelected];
    [self.userButton setTitle:login forState:UIControlStateDisabled];
}

#pragma mark Actions

- (IBAction)openAuthor:(id)sender {
    if ([self.delegate respondsToSelector:@selector(openURL:)]) {
        [self.delegate openURL:self.comment.user.htmlURL];
    }
}

#pragma mark Layout

- (CGFloat)heightWithoutContentText {
	return 32.0f;
}

- (CGFloat)contentTextMarginTop {
	return 0.0f;
}

@end