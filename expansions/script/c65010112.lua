--瓶之骑士 清泉少女
function c65010112.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,65010112)
	e1:SetCondition(c65010112.hspcon)
	e1:SetValue(c65010112.hspval)
	c:RegisterEffect(e1)
	--bottle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65010113)
	e2:SetCondition(c65010112.con)
	e2:SetTarget(c65010112.tg)
	e2:SetOperation(c65010112.op)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65010112.cocon)
	e3:SetTarget(c65010112.cotg)
	e3:SetOperation(c65010112.coop)
	c:RegisterEffect(e3)
end
function c65010112.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c65010112.hspzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c65010112.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,1-tp))
	end
	return bit.bnot(zone)
end
function c65010112.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c65010112.hspzone(tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c65010112.hspval(e,c)
	local tp=c:GetControler()
	local zone=c65010112.hspzone(tp)
	return 0,zone
end
function c65010112.confil(c,tp)
	return c:IsSetCard(0x5da0) and c:IsControler(tp)
end
function c65010112.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65010112.confil,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c65010112.tgfil(c)
	return not c:IsSetCard(0x5da0) or not c:IsFaceup()
end
function c65010112.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c65010112.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(tp,1)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
function c65010112.cocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65010112.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65010112.coop(e,tp,eg,ep,ev,re,r,rp)
	local sp=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(sp,LOCATION_MZONE)>0 and not e:GetHandler():IsControler(sp) then
		Duel.GetControl(e:GetHandler(),sp)
	end
end

