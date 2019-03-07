--開闢の予言者
local m=17090008
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--reborn preparation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY+LOCATION_SZONE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_DECK)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.epcon)
	e4:SetOperation(cm.epop)
	c:RegisterEffect(e4)
	--draw and to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(cm.drtg)
	e5:SetOperation(cm.drop)
	c:RegisterEffect(e5)
	--cannot be target/effect indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function cm.cfilter(c,tp)
	return c:IsLevelBelow(10) and c:GetSummonPlayer()==tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.disfilter(c)
	return c:IsLevelBelow(10)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.disfilter,nil)
	local tc=g:GetFirst():GetLevel()
	while tc do
		e:GetHandler():RegisterFlagEffect(17090008+tc,nil,0,0)
		tc=g:GetNext()
	end
end
function cm.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
	and e:GetHandler():GetFlagEffect(17090008+1)>0
	and e:GetHandler():GetFlagEffect(17090008+2)>0
	and e:GetHandler():GetFlagEffect(17090008+3)>0
	and e:GetHandler():GetFlagEffect(17090008+4)>0
	and e:GetHandler():GetFlagEffect(17090008+5)>0
	and e:GetHandler():GetFlagEffect(17090008+6)>0
	and e:GetHandler():GetFlagEffect(17090008+7)>0
	and e:GetHandler():GetFlagEffect(17090008+8)>0
	and e:GetHandler():GetFlagEffect(17090008+9)>0
	and e:GetHandler():GetFlagEffect(17090008+10)>0
end
function cm.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return iCount(0,tp,m,1) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end