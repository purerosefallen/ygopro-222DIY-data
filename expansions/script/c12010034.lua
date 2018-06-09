--靜儀式 記憶之海
function c12010034.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010034,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c12010034.condition)
	e1:SetTarget(c12010034.target)
	e1:SetOperation(c12010034.activate)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12010034,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,12010034)
	e3:SetCost(c12010034.cost)
	e3:SetTarget(c12010034.target2)
	e3:SetOperation(c12010034.operation2)
	c:RegisterEffect(e3)
end
function c12010034.cfilter(c)
	return c:IsSetCard(0xfba) and c:IsReleasable()
end
function c12010034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010034.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	local cg=Duel.SelectMatchingCard(tp,c12010034.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Release(cg,REASON_COST)
end
function c12010034.nfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c12010034.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c12010034.nfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12010034.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local eg=Duel.SelectTarget(tp,c12010034.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c12010034.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c12010034.filter(c,p)
	return c:GetControler()==p and c:IsOnField() and (c:IsSetCard(0xfba) or c:IsSetCard(0xfbc)) and c:IsFaceup()
end
function c12010034.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c12010034.filter,nil,tp)-tg:GetCount()>1
end
function c12010034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12010034.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
----   function c12010034.cfilter(c,tp)
--  return  c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
--	  and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) and (c:--  IsSetCard(0xfba) and c:IsType(TYPE_MONSTER))
----   end
----   function c12010034.con(e,tp,eg,ep,ev,re,r,rp)
--  return eg:IsExists(c12010034.cfilter,1,nil,tp)
--   end
--   function c12010034.spfilter(c,e,tp)
--	 return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false,POS_FACEUP) and c:IsSetCard(0xfba)
--   end
--   function c12010034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--	 if chk==0 then return Duel.IsExistingMatchingCard(c12010034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
--	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
--   end
--   function c12010034.spop(e,tp,eg,ep,ev,re,r,rp)
--	 local c=e:GetHandler()
--	 if not c:IsRelateToEffect(e) then return false end
--	 if Duel.GetLocationCountFromEx(tp)<1 then return false end
--	 if not Duel.IsExistingMatchingCard(c12010034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
--	 local sg=Duel.SelectMatchingCard(tp,c12010034.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
--	 local sc=sg:GetFirst()
--	 if sc then 
--		   Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
--	 end
--   end