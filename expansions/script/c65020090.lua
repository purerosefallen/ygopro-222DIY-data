--恶噬灵 残兵
function c65020090.initial_effect(c)
	--glutton
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65020090,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65020090)
	e1:SetCondition(c65020090.con0)
	e1:SetCost(c65020090.zisu)
	e1:SetTarget(c65020090.tg)
	e1:SetOperation(c65020090.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c65020090.con1)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c65020090.con2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(65020090,ACTIVITY_SPSUMMON,c65020090.counterfilter)
	--realease
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65020090,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,65020091)
	e4:SetCost(c65020090.cost)
	e4:SetTarget(c65020090.thtg)
	e4:SetOperation(c65020090.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c65020090.con3)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c65020090.con4)
	c:RegisterEffect(e6)
end
function c65020090.con0(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65020093)
end
function c65020090.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65020093)
end
function c65020090.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65020095)
end
function c65020090.counterfilter(c)
	return c:IsSetCard(0xada3)
end
function c65020090.zisu(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65020090,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65020090.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c65020090.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xada3)
end
function c65020090.tgfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65020090.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c65020090.tgfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020090.tgfil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,c65020090.tgfil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65020090.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65020090.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65020092) and not Duel.IsPlayerAffectedByEffect(tp,65020093)
end
function c65020090.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65020092) and Duel.IsPlayerAffectedByEffect(tp,65020093)
end
function c65020090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65020090.fil(c)
	return c:IsSetCard(0xada3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c65020090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65020090.fil,tp,LOCATION_GRAVE,0,1,nil) end
end
function c65020090.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c65020090.fil,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end