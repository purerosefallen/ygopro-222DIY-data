--炼金工作室-科尔涅莉雅
function c4212310.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(4210011,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SPECIAL)
	e0:SetCondition(c4212310.spcon)
	e0:SetOperation(c4212310.spop)
	c:RegisterEffect(e0)
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetValue(c4212310.slevel)
	c:RegisterEffect(e1)
	--copy trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4212310,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0x3c0)
	e2:SetCountLimit(1,4212310)
	e2:SetCost(c4212310.cost)
	e2:SetCondition(c4212310.condition)
	e2:SetOperation(c4212310.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4212310,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,4212310)
	e3:SetCost(c4212310.cost)
	e3:SetOperation(c4212310.operation)
	c:RegisterEffect(e3)
--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c4212310.reptg)
	e4:SetOperation(c4212310.repop)
	c:RegisterEffect(e4)
end
function c4212310.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 3*65536+lv
end
function c4212310.cfilter(c,sc)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
		and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)  
end
function c4212310.spcon(e,c)	
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	return ft>0 and Duel.IsExistingMatchingCard(c4212310.cfilter,tp,LOCATION_SZONE,0,3,nil,c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false,POS_FACEUP,tp)
end
function c4212310.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c = e:GetHandler()
	local sg = Duel.SelectMatchingCard(tp,c4212310.cfilter,tp,LOCATION_SZONE,0,3,3,nil,c)
	c:SetMaterial(sg)
	Duel.Overlay(c,sg)
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
end
function c4212310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c4212310.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and not Duel.CheckEvent(EVENT_CHAINING)
end
function c4212310.filter1(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:CheckActivateEffect(false,true,false)~=nil
end
function c4212310.mfilter(c,re)
	return c:IsPreviousLocation(LOCATION_OVERLAY) and c:IsReason(REASON_COST)
end
function c4212310.tgfilter(c,e,re)
	return Group.FromCards(e:GetHandler(),(c:GetReasonEffect() and {c:GetReasonEffect():GetOwner()} or {nil})[1]):FilterCount(function(c) return c:IsType(0x7) end,nil) == 1 
end
function c4212310.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-300)
	c:RegisterEffect(e1)
	local g = Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE):Filter(c4212310.tgfilter,nil,e,e):Filter(c4212310.mfilter,nil)
	local tc = g:Select(tp,1,1,nil):GetFirst()
	local te= tc:CheckActivateEffect(false,true,true)
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c4212310.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) then
		if c:CheckActivateEffect(false,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
function c4212310.repfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c4212310.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c4212310.repfilter,tp,LOCATION_ONFIELD,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c4212310.repfilter,tp,LOCATION_ONFIELD,0,1,1,c,e)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c4212310.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end