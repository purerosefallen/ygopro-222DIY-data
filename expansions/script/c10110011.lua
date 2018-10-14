--聚镒素 洪流暴龙
function c10110011.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10110011.ffilter,2,true)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110011,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10110011)
	e1:SetCost(c10110011.cpcost)
	e1:SetTarget(c10110011.cptg)
	e1:SetOperation(c10110011.cpop)
	c:RegisterEffect(e1)
	--copy effect monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110011,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10110011)
	e2:SetLabelObject(nil)
	e2:SetCost(c10110011.tgcost)
	e2:SetTarget(c10110011.tgtg)
	e2:SetOperation(c10110011.tgop)
	c:RegisterEffect(e2)
end
function c10110011.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10110011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false end
	   e:SetLabel(0)
	   return Duel.IsExistingMatchingCard(c10110011.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10110011.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c10110011.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetLabelObject()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	c:ReplaceEffect(tc:GetOriginalCodeRule(),RESET_EVENT+0x1fe0000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(tc:GetAttribute())
	c:RegisterEffect(e1)
end
function c10110011.cfilter(c)
	return c:IsSetCard(0x9332) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c10110011.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10110011.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9332) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c10110011.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10110011.filter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10110011.filter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c10110011.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10110011.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and (not sg or sg:IsExists(Card.IsFusionSetCard,1,nil,0x9332))
end