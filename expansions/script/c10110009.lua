--聚镒素 熔金
function c10110009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10110009.ffilter,2,true)
	--destroy monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110009,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c10110009.descon1)
	e1:SetTarget(c10110009.destg)
	e1:SetOperation(c10110009.desop)
	e1:SetLabel(TYPE_MONSTER)
	c:RegisterEffect(e1)
	--destroy S/T
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110009,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c10110009.descon)
	e2:SetTarget(c10110009.destg)
	e2:SetOperation(c10110009.desop)
	e2:SetLabel(TYPE_SPELL+TYPE_TRAP)
	c:RegisterEffect(e2)  
end
function c10110009.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10110009.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c10110009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10110009.desfilter,tp,0,LOCATION_ONFIELD,nil,e:GetLabel())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10110009.desfilter(c,cardtype)
	return c:IsType(cardtype) and (cardtype~=TYPE_MONSTER or c:IsFaceup())
end
function c10110009.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10110009.desfilter,tp,0,LOCATION_ONFIELD,nil,e:GetLabel())
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetLabel()==TYPE_MONSTER then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CHANGE_DAMAGE)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(0,1)
	   e1:SetValue(0)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e2,tp)
	end
end
function c10110009.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and (not sg or sg:IsExists(Card.IsFusionSetCard,1,nil,0x9332))
end