--回望辉忆之原
function c65020062.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c65020062.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65020062)
	e1:SetCondition(c65020062.spcon)
	e1:SetTarget(c65020062.sptg)
	e1:SetOperation(c65020062.spop)
	c:RegisterEffect(e1)
end
function c65020062.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function c65020062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65020062.filter(c,tp,e)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c65020062.filter2,tp,LOCATION_GRAVE,0,1,nil,c,e)
end
function c65020062.filter2(c,mc,e)
	local code=c:GetCode()
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e) and c65020062.isfit(c,mc)
end
function c65020062.isfit(c,mc)
	return (mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))) or aux.IsCodeListed(mc,c:GetCode())
end
function c65020062.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c65020062.filter,tp,LOCATION_GRAVE,0,1,nil,tp,e) end
	local g1=Duel.SelectTarget(tp,c65020062.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp,e)
	local mc=g1:GetFirst()
	local g2=Duel.SelectTarget(tp,c65020062.filter2,tp,LOCATION_GRAVE,0,1,1,nil,mc,e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,tp,LOCATION_GRAVE)
end
function c65020062.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsType,nil,TYPE_SPELL)
	local g2=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	if g1:GetCount()>0 then
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and g2:GetCount()>0 then
			Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
		end
	end
end