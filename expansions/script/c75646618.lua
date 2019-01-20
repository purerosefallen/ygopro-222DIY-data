--幻海深渊 伊瑟琳
function c75646618.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c75646618.matfilter,1,1)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,75646618)
	e1:SetCondition(c75646618.tgcon)
	e1:SetTarget(c75646618.tgtg)
	e1:SetOperation(c75646618.tgop)
	c:RegisterEffect(e1)
	--return grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c75646618.con)
	e2:SetTarget(c75646618.tgtg1)
	e2:SetOperation(c75646618.tgop1)
	c:RegisterEffect(e2)
	c75646618.key_effect=e2
end
c75646618.card_code_list={75646600}
function c75646618.matfilter(c)
	return not c:IsCode(75646618) and c:IsLinkRace(RACE_CYBERSE)
end
function c75646618.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetLP(tp)<=4000
end
function c75646618.filter(c)
	return aux.IsCodeListed(c,75646600) and c:IsAbleToGrave()
end
function c75646618.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646618.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75646618.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646618.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c75646618.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75646600)~=0
end
function c75646618.tgfilter(c)
	return aux.IsCodeListed(c,75646600)
end
function c75646618.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c75646618.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646618.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74586817,2))
	local g=Duel.SelectTarget(tp,c75646618.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c75646618.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end