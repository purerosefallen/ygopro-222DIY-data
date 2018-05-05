--虚幻法师的禁忌创造物
function c66913802.initial_effect(c)
c66913802.dfc_front_side=66913802
c66913802.dfc_back_side=66913830
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x371),2,true)   
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66913802)
	e2:SetTarget(c66913802.changetg)
	e2:SetOperation(c66913802.changeop)
	e2:SetCondition(c66913802.changecon)
	c:RegisterEffect(e2)
end
function c66913802.changecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=9
end
function c66913802.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c66913802.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
end


