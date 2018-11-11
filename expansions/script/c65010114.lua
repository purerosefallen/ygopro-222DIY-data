--瓶之雷兽 丘
function c65010114.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,65010114)
	e1:SetCondition(c65010114.hspcon)
	e1:SetValue(c65010114.hspval)
	c:RegisterEffect(e1)
	--cannot sp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetCondition(c65010114.con)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65010114.cocon)
	e3:SetTarget(c65010114.cotg)
	e3:SetOperation(c65010114.coop)
	c:RegisterEffect(e3)
end
function c65010114.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c65010114.hspzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c65010114.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,1-tp))
	end
	return bit.bnot(zone)
end
function c65010114.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c65010114.hspzone(tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c65010114.hspval(e,c)
	local tp=c:GetControler()
	local zone=c65010114.hspzone(tp)
	return 0,zone
end
function c65010114.confil(c,tp)
	return not c:GetOwner()==tp
end
function c65010114.con(e,c)
	local tp=e:GetControler()
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x5da0) and Duel.IsExistingMatchingCard(c65010114.confil,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c65010114.cocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65010114.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65010114.coop(e,tp,eg,ep,ev,re,r,rp)
	local sp=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(sp,LOCATION_MZONE)>0 and not e:GetHandler():IsControler(sp) then
		Duel.GetControl(e:GetHandler(),sp)
	end
end


