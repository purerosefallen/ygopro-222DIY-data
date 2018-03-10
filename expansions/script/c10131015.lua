--自由-强袭
function c10131015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10131015)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c10131015.target)
	e1:SetOperation(c10131015.activate)
	c:RegisterEffect(e1)   
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131015,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10131115)
	e2:SetCondition(c10131015.tdcon)
	e2:SetTarget(c10131015.tdtg)
	e2:SetOperation(c10131015.tdop)
	c:RegisterEffect(e2)  
end
function c10131015.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c10131015.tdfilter(c)
	return c:IsSetCard(0x5338) and c:IsAbleToDeck()
end
function c10131015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10131015.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10131015.tdfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10131015.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10131015.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
	   Duel.ShuffleDeck(tp)
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10131015.filter(c,e,tp,rc)
	return c:IsFaceup() and c:IsSetCard(0x5338) and Duel.IsExistingMatchingCard(c10131015.filter2,tp,LOCATION_ONFIELD,0,1,c,e,rc) and c:IsType(TYPE_MONSTER)
end
function c10131015.filter2(c,e,rc)
	return c:IsCanBeEffectTarget(e) and c~=rc
end
function c10131015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10131015.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c10131015.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c10131015.filter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),e,e:GetHandler())
	local g3=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c10131015.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sg=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	if sg:GetCount()>0 then
	   sg:Merge(tg)
	   Duel.Destroy(sg,REASON_EFFECT)
	end
end