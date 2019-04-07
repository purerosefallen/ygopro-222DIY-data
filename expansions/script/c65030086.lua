--现实坠落
function c65030086.initial_effect(c)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65030086.con)
	e1:SetCost(c65030086.cost)
	e1:SetTarget(c65030086.tg)
	e1:SetOperation(c65030086.op)
	c:RegisterEffect(e1)
	--tofield
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65030086.tfcon)
	e2:SetTarget(c65030086.tftg)
	e2:SetOperation(c65030086.tfop)
	c:RegisterEffect(e2)
end
c65030086.card_code_list={65030086}
function c65030086.egfil(c,tp)
	return c:GetPreviousControler()==tp and c:IsLocation(LOCATION_DECK)
end
function c65030086.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030086.egfil,1,nil,tp)
end
function c65030086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(65030086)==0 end
	c:RegisterFlagEffect(65030086,RESET_CHAIN,0,1)
end
function c65030086.tgfil(c,e,tp)
	return ((c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp)>0)) and aux.IsCodeListed(c,65030086) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030086.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030086.tgfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c65030086.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030086.tgfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65030086.confil(c)
	return c:IsLocation(LOCATION_MZONE) and aux.IsCodeListed(c,65030086) 
end
function c65030086.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and c65030086.confil(rc)
end
function c65030086.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65030086.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end