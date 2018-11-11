--瓶之骑士 金鱼姬
function c65010110.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,65010110)
	e1:SetCondition(c65010110.hspcon)
	e1:SetValue(c65010110.hspval)
	c:RegisterEffect(e1)
	--bottle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65010111)
	e2:SetCondition(c65010110.con)
	e2:SetTarget(c65010110.tg)
	e2:SetOperation(c65010110.op)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65010110.cocon)
	e3:SetTarget(c65010110.cotg)
	e3:SetOperation(c65010110.coop)
	c:RegisterEffect(e3)
end
function c65010110.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c65010110.hspzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c65010110.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,1-tp))
	end
	return bit.bnot(zone)
end
function c65010110.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c65010110.hspzone(tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c65010110.hspval(e,c)
	local tp=c:GetControler()
	local zone=c65010110.hspzone(tp)
	return 0,zone
end
function c65010110.confil(c,tp)
	return c:IsSetCard(0x5da0) and c:IsControler(tp)
end
function c65010110.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65010110.confil,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c65010110.tgfil(c)
	return not c:IsSetCard(0x5da0) or not c:IsFaceup()
end
function c65010110.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetMatchingGroupCount(c65010110.tgfil,tp,LOCATION_MZONE,0,1,nil)
	if num>2 then num=2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,num,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,1-tp,1)
end
function c65010110.op(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(c65010110.tgfil,tp,LOCATION_MZONE,0,1,nil)
	if num>2 then num=2 end
	local g=Duel.SelectMatchingCard(tp,c65010110.tgfil,tp,LOCATION_MZONE,0,num,num,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
function c65010110.cocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65010110.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65010110.coop(e,tp,eg,ep,ev,re,r,rp)
	local sp=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(sp,LOCATION_MZONE)>0 and not e:GetHandler():IsControler(sp) then
		Duel.GetControl(e:GetHandler(),sp)
	end
end
