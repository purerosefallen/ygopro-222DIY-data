--FOLKS OF DRAEM
function c65060021.initial_effect(c)
	c:SetUniqueOnField(LOCATION_SZONE,0,65060021)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65060021.target)
	e1:SetOperation(c65060021.activate)
	c:RegisterEffect(e1)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c65060021.sumfilter)
	e4:SetOperation(c65060021.sumsuc)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e5)
	--Pos Change
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_POSITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c65060021.postar)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e6)
end
function c65060021.sumfilter(e,c)
	return c:IsSetCard(0x6da4) and c:GetSummonPlayer()==e:GetHandlerPlayer()
end
function c65060021.filter(c)
	return c:IsSetCard(0x6da4) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c65060021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060021.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65060021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65060021.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65060021.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c65060021.postar(e,c)
	return c:IsPosition(POS_FACEUP)
end