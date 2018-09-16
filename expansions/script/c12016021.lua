--炫灵姬启动
function c12016021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12016021.target)
	e1:SetOperation(c12016021.activate)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12016021,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c12016021.thcon)
	e4:SetTarget(c12016021.thtg)
	e4:SetOperation(c12016021.thop)
	c:RegisterEffect(e4)
end
function c12016021.filter(c)
	return c:IsSetCard(0xfb9) and c:IsAbleToHand() and not c:IsCode(12016021)
end
function c12016021.filter1(c)
	return c:IsSetCard(0xfb9) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM) 
end
function c12016021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12016021.filter,tp,LOCATION_DECK,0,1,nil) and (Duel.IsExistingMatchingCard(c12016021.filter1,tp,LOCATION_DECK,0,1,nil) or Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)<3 ) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
end
function c12016021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12016021.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12016021,1))
	local g=Duel.SelectMatchingCard(tp,c12016021.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
		end
	end
	Duel.BreakEffect()
	Duel.DiscardHand(tp,c12016021.filter,1,1,REASON_DISCARD+REASON_EFFECT)
end
function c12016021.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0xfb9) 
		and c:IsPreviousPosition(POS_FACEUP) and c:IsControler(tp)
end
function c12016021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12016021.cfilter,1,nil,tp)
end
function c12016021.thfilter(c)
	return (c:IsType(TYPE_SPIRIT) or c:GetType()==0x82) and c:IsAbleToHand()
end
function c12016021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12016008,0,0x4011,1500,1500,4,RACE_WINDBEAST,ATTRIBUTE_LIGHT)
		end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12016021.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12016008,0,0x4011,1600,1600,4,RACE_WINDBEAST,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,12016008)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
