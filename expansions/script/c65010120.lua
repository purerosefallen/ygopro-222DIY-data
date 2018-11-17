--瓶之骑士交信
function c65010120.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,65010120+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65010120.con)
	e1:SetTarget(c65010120.target)
	e1:SetOperation(c65010120.activate)
	c:RegisterEffect(e1)
end
function c65010120.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandlerPlayer()~=tp
end
function c65010120.spfil(c,e,tp)
	return c:IsSetCard(0x5da0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c65010120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010120.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
end
function c65010120.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,c65010120.repop)
end
function c65010120.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	if not (Duel.IsExistingMatchingCard(c65010120.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0) then return end
	local g=Duel.SelectMatchingCard(tp,c65010120.spfil,tp,0,LOCATION_HAND+LOCATION_GRAVE,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
end