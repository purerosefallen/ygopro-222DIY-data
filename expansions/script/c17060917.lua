--未来型フェデルマ
local m=17060917
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1160)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCost(cm.reg)
	c:RegisterEffect(e0)
	--to ex
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.tecon)
	e1:SetTarget(cm.tetg)
	e1:SetOperation(cm.teop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
cm.is_named_with_Ma_Elf=1
function cm.IsMa_Elf(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Ma_Elf 
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(17060917)~=0
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return iCount(0,tp,m,1) and Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_PENDULUM)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsCode(17060917) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToGrave()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return iCount(0,tp,m,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgfilter),tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE+LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end