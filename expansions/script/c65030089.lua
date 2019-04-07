--锈色的独行前路
function c65030089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65030089+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65030089.tg)
	e1:SetOperation(c65030089.op)
	c:RegisterEffect(e1)
end
c65030089.card_code_list={65030086}
function c65030089.b1fil(c,e,tp)
	return aux.IsCodeListed(c,65030086) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65030089.b2fil(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and aux.IsCodeListed(c,65030086) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden()
end
function c65030089.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65030089.b1fil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c65030089.b2fil,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then return b1 or b2 end
	local m=3
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65030089,0),aux.Stringid(65030089,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	e:SetLabel(m)
	if m==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function c65030089.op(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c65030089.b1fil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c65030089.b2fil,tp,LOCATION_EXTRA,0,1,nil)
	if m==0 and b1 then
		local g1=Duel.SelectMatchingCard(tp,c65030089.b1fil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	elseif m==1 and b2 then
		local g2=Duel.SelectMatchingCard(tp,c65030089.b2fil,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.MoveToField(g2:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end