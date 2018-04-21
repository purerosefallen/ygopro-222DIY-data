--崩坏的魔女 艾莲
function c71424529.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c71424529.matfilter,2)
	c:EnableReviveLimit()
	--present exchange
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c71424529.tg1)
	e1:SetCondition(c71424529.con1)
	e1:SetOperation(c71424529.op1)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetDescription(aux.Stringid(71424529,0))
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_TO_GRAVE)
	e1a:SetCondition(c71424529.con1a)
	--control
	--currently null
end
function c71424529.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
end
function c71424529.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,2,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,nil) end
end
function c71424529.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71424529.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,1-tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg1=g1:Select(tp,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local rg2=g2:Select(1-tp,2,2,nil)
	rg1:Merge(rg2)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.Remove(rg1,POS_FACEDOWN,REASON_EFFECT)
	local tc=rg1:GetFirst()
	while tc do
		tc:RegisterFlagEffect(71424529,RESET_EVENT+0x1fe0000,0,0,fid)
		tc=rg1:GetNext()
	end
	rg1:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(rg1)
	e1:SetCondition(c71424529.thcon)
	e1:SetOperation(c71424529.thop)
	Duel.RegisterEffect(e1,tp)
end
function c71424529.thfilter(c,fid)
	return c:GetFlagEffectLabel(71424529)==fid
end
function c71424529.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:FilterCount(c71424529.thfilter,nil,e:GetLabel())<4 then
		g:DeleteGroup()
		return false
	else return true end
end
function c71424529.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	g:DeleteGroup()
	Duel.SendtoHand(tc1,1-tc1:GetControler(),REASON_EFFECT)
	Duel.SendtoHand(tc2,1-tc2:GetControler(),REASON_EFFECT)
	local tc3=g:GetFirst()
	local tc4=g:GetNext()
	g:DeleteGroup()
	Duel.SendtoHand(tc3,1-tc3:GetControler(),REASON_EFFECT)
	Duel.SendtoHand(tc4,1-tc4:GetControler(),REASON_EFFECT)
end
function c71424529.con1a(e,tp,eg,ep,ev,re,r,rp)
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_MZONE)
end