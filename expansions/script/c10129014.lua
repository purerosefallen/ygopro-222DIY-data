--地狱鬼神 美洛厄尼斯
function c10129014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10129014.splimit)
	c:RegisterEffect(e0)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10129014,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10129014)
	e1:SetCondition(c10129014.rmcon)
	e1:SetTarget(c10129014.rmtg)
	e1:SetOperation(c10129014.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10129014,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c10129014.tfcon)
	e2:SetTarget(c10129014.tftg)
	e2:SetOperation(c10129014.tfop)
	c:RegisterEffect(e2)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)
	e2:SetLabelObject(sg)
end
c10129014.outhell_fusion=true
function c10129014.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousPosition(POS_FACEUP) and c:GetFlagEffect(10129114)>0 then return true
	else e:GetLabelObject():Clear()
	end
end
function c10129014.tffilter(c,e,tp,eg)
	return eg:IsContains(c) and c:GetFlagEffect(10129014)>0 and c:IsReason(REASON_TEMPORARY) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c10129014.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10129014.tffilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp,e:GetLabelObject()) end
end
function c10129014.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10129014.tffilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp,e:GetLabelObject()):GetFirst()
	if tc and Duel.ReturnToField(tc) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CHANGE_RACE)
	   e1:SetReset(RESET_EVENT+0xfe0000)
	   e1:SetValue(RACE_ZOMBIE)
	   tc:RegisterEffect(e1)
	   if tc:IsControler(1-tp) and tc:IsControlerCanBeChanged() and Duel.SelectYesNo(tp,aux.Stringid(10129014,2)) then
		  Duel.GetControl(tc,tp)
	   end
	end
	e:GetLabelObject():Clear()
end
function c10129014.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+101
end
function c10129014.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsRelateToBattle()
end
function c10129014.rfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function c10129014.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c10129014.rfilter,tp,LOCATION_MZONE,0,1,nil) and bc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
end
function c10129014.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local bc=c:GetBattleTarget()
	if not bc:IsRelateToBattle() or not c:IsRelateToBattle() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10129014.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:RegisterFlagEffect(10129114,RESET_EVENT+RESET_TOFIELD+RESET_OVERLAY,0,1)
	if g:GetCount()>0 then
	   g:AddCard(bc)
	   Duel.HintSelection(g)
	   if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		  local rg=Duel.GetOperatedGroup()
		  local rc=rg:GetFirst()
		  while rc do
				rc:RegisterFlagEffect(10129014,RESET_EVENT+0x1fe0000,0,0)
				e:GetLabelObject():AddCard(rc)
		  rc=rg:GetNext()
		  end
	   end
	end
end