--赫里奥波里斯的托特
function c22230007.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22230007)
	e1:SetCondition(c22230007.spcon1)
	e1:SetTarget(c22230007.sptg)
	e1:SetOperation(c22230007.spop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22230007,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22230007)
	e2:SetCondition(c22230007.spcon2)
	e2:SetTarget(c22230007.sptg)
	e2:SetOperation(c22230007.spop)
	c:RegisterEffect(e2)
	--Return to Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22230007,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,22230007)
	e3:SetTarget(c22230007.thtg)
	e3:SetOperation(c22230007.thop)
	c:RegisterEffect(e3)
end
function c22230007.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22230007.spcfilter1(c)
	return c22230007.IsValhalla(c) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_REMOVED)
end
function c22230007.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22230007.spcfilter1,1,nil)
end
function c22230007.spcfilter2(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c22230007.IsValhalla(c) and c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_MONSTER)
end
function c22230007.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22230007.spcfilter2,1,nil,tp)
end
function c22230007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22230007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(c22230007.indtg)
		e1:SetValue(c22230007.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22230007.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22230007.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c22230007.thfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and c:IsFaceup()
end
function c22230007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22230007.thfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c22230007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22230007.thfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end