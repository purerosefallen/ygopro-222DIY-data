--宇宙战争机器 爆核
function c13257231.initial_effect(c)
	c:EnableCounterPermit(0x353)
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e10)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_SPSUMMON_PROC)
	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e11:SetRange(LOCATION_HAND)
	e11:SetTargetRange(POS_FACEUP_ATTACK,1)
	e11:SetCondition(c13257231.spcon)
	e11:SetOperation(c13257231.spop)
	c:RegisterEffect(e11)
	--spsummon cost
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_SPSUMMON_COST)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetCost(c13257231.spcost)
	e12:SetOperation(c13257231.spcop)
	c:RegisterEffect(e12)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257231.desreptg)
	e1:SetOperation(c13257231.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257231.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--deck equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257231,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c13257231.eqtg)
	e4:SetOperation(c13257231.eqop)
	c:RegisterEffect(e4)
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13257231,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c13257231.discon)
	e5:SetCost(c13257231.discost)
	e5:SetTarget(c13257231.distg)
	e5:SetOperation(c13257231.disop)
	c:RegisterEffect(e5)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SUMMON_SUCCESS)
	e13:SetOperation(c13257231.bgmop)
	c:RegisterEffect(e13)
	Duel.AddCustomActivityCounter(13257231,ACTIVITY_SPSUMMON,c13257231.counterfilter)
	Duel.AddCustomActivityCounter(13257231,ACTIVITY_NORMALSUMMON,c13257231.counterfilter)
	c:RegisterFlagEffect(13257200,0,0,0,1)
	eflist={"deck_equip",e5}
	c13257201[c]=eflist
	
end
function c13257231.counterfilter(c)
	return not c:IsRace(RACE_MACHINE)
end
function c13257231.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x353)>0 end
	return true
end
function c13257231.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x353,1,REASON_EFFECT)
end
function c13257231.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x353,2)
end
function c13257231.filter1(c,tp,rg)
	return rg:IsExists(c13257231.filter2,1,c,tp,c)
end
function c13257231.filter2(c,tp,mc)
	local mg=Group.FromCards(c,mc)
	return Duel.GetMZoneCount(1-tp,mg,tp)>0
end
function c13257231.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_MZONE,nil)
	return rg:IsExists(c13257231.filter1,1,nil,tp,rg)
end
function c13257231.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=rg:FilterSelect(tp,c13257231.filter1,1,1,nil,tp,rg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=rg:FilterSelect(tp,c13257231.filter2,1,1,g:GetFirst(),tp,g:GetFirst())
	g:Merge(g2)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13257231.eqfilter(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257231.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257231.eqfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257231.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257231.eqfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257231.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c13257231.costfilter(c)
	return c:IsSetCard(0x353) and c:IsDiscardable()
end
function c13257231.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13257231.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,c13257231.costfilter,1,1,REASON_COST,nil)
end
function c13257231.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c13257231.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c13257231.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c13257231.spcop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13257231.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function c13257231.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE)
end
function c13257231.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257231,4))
end
