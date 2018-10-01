--落樱
function c65071100.initial_effect(c)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c65071100.tgcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071100.tgtg)
	e2:SetOperation(c65071100.tgop)
	c:RegisterEffect(e2)
end
function c65071100.tgfil(c,tp)
	return c:GetPreviousControler()==tp
end

function c65071100.tgcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local mg2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return eg:IsExists(c65071100.tgfil,1,nil,tp) and mg2:GetCount()>mg1:GetCount() 
end

function c65071100.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local mg2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return mg2:GetCount()>mg1:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end

function c65071100.tgop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local mg2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local rec=0
	if mg2:GetCount()>mg1:GetCount() then
		local ct1=mg1:GetCount()
		local ct2=mg2:GetCount()
		local st=ct2-ct1
		local g=mg2:FilterSelect(tp,aux.TRUE,st,st,nil)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			while tc do
				rec=rec+tc:GetBaseAttack()
				tc=g:GetNext()
			end
			Duel.Recover(tp,rec,REASON_EFFECT)
			Duel.Recover(1-tp,rec,REASON_EFFECT)
		end
	end
end