--从不困惑的白沢球
function c22220122.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),2,3,c22220122.ovfilter,aux.Stringid(22220122,0))
	c:EnableReviveLimit()
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetTarget(c22220122.eftg)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_GRAVE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(c22220122.disable)
	c:RegisterEffect(e2)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22220122.reccon)
	e2:SetOperation(c22220122.recop)
	c:RegisterEffect(e2)
	--returnhand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c22220122.rhop)
	c:RegisterEffect(e3)
end
function c22220122.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22220121)
end
function c22220122.eftg(e,c)  
	return c:IsType(TYPE_MONSTER)
end
function c22220122.disable(e,c)
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c22220122.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c22220122.recop(e,tp,eg,ep,ev,re,r,rp)
	local mg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local lg=mg:Filter(Card.IsLevelAbove,nil,0)
	local rg=mg:Filter(Card.IsRankAbove,nil,0)
	local lsum=lg:GetSum(Card.GetLevel)
	local rsum=lg:GetSum(Card.GetRank)
	local val=(lsum+rsum)*100
	Duel.Recover(tp,val,REASON_EFFECT)
end
function c22220122.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local fg=c:GetColumnGroup()
	og:Merge(fg)
	og:AddCard(c)
	Duel.SendtoHand(og,nil,REASON_EFFECT)
end