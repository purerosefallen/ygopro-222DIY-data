--暗堕型佣兵亚瑟
local m=17060818
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ep effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060818,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.epcon)
	e1:SetTarget(cm.eptg)
	e1:SetOperation(cm.epop)
	c:RegisterEffect(e1)
	--special summon from hand and grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,17060818)
	e2:SetCondition(cm.hspcon)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060818,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
end
cm.is_named_with_Mercenary_Arthur=1
cm.is_named_with_Million_Arthur=1
cm.is_named_with_Dark_Degenerate=1
function cm.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function cm.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function cm.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function cm.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.hspfilter(c,ft,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) 
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and c:IsControler(tp) 
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,ft,tp)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetLevel()>0
end
function cm.filter2(c,tp)
	return cm.filter1(c) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter2(chkc,tp) end
	if chk==0 then return iCount(0,tp,m,1) and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,nil,tp) and g1:GetClassCount(Card.GetLevel)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
end